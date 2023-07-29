from hitchstory import StoryCollection, BaseEngine, validate, Failure
from hitchstory import GivenDefinition, GivenProperty, InfoDefinition, InfoProperty
from strictyaml import EmptyDict, Str, Map, Optional, Enum, MapPattern, Bool
from hitchstory import no_stacktrace_for, strings_match
from hitchrunpy import ExamplePythonCode, HitchRunPyException
from commandlib import Command
from commandlib.exceptions import CommandExitError
from path import Path
import colorama
import shlex
import re


class Engine(BaseEngine):
    """Python engine for running tests."""

    given_definition = GivenDefinition(
        files=GivenProperty(
            MapPattern(Str(), Str()),
            inherit_via=GivenProperty.OVERRIDE,
        ),
        website=GivenProperty(
            MapPattern(Str(), Str()),
            inherit_via=GivenProperty.OVERRIDE,
        ),
    )

    info_definition = InfoDefinition(
        status=InfoProperty(schema=Enum(["experimental", "stable"])),
        category=InfoProperty(schema=Enum(["behavior", "runner", "inheritance", "parameterization", "documentation",])),
        docs=InfoProperty(schema=Str()),
    )

    def __init__(self, paths, python_path, rewrite=False, cprofile=False, timeout=5.0):
        self.path = paths
        self._rewrite = rewrite
        self._python_path = python_path
        self._cprofile = cprofile
        self._timeout = timeout

    def set_up(self):
        """Set up the environment ready to run the stories."""
        self.path.q = Path("/tmp/q")
        self.path.state = self.path.gen.joinpath("state")
        self.path.working = self.path.state / "working"

        if self.path.q.exists():
            self.path.q.remove()
        if self.path.state.exists():
            self.path.state.rmtree(ignore_errors=True)
        self.path.state.mkdir()
        
        self._included_files = []

        for filename, contents in list(self.given.get("files", {}).items()):
            self.path.state.joinpath(filename).write_text(self.given["files"][filename])
            self._included_files.append(self.path.state.joinpath(filename))

        self.python = Command(self._python_path)

    @no_stacktrace_for(AssertionError)
    @no_stacktrace_for(HitchRunPyException)
    @validate(
        code=Str(),
        will_output=Str(),
        raises=Map({Optional("type"): Str(), Optional("message"): Str()}),
    )
    def run(self, code, will_output=None, raises=None):
        self.example_py_code = (
            ExamplePythonCode(self.python, self.path.state)
            .with_terminal_size(160, 160)
            .with_setup_code(self.given.get("setup", ""))
            .include_files(*self._included_files)
            .with_timeout(self._timeout)
        )
        to_run = self.example_py_code.with_code(code)

        if self._cprofile:
            to_run = to_run.with_cprofile(
                self.path.profile.joinpath("{0}.dat".format(self.story.slug))
            )

        result = (
            to_run.expect_exceptions().run() if raises is not None else to_run.run()
        )

        actual_output = self._story_friendly_output(result.output)

        if will_output is not None:
            try:
                strings_match(will_output, actual_output)
            except Failure:
                if self._rewrite:
                    self.current_step.rewrite("will_output").to(actual_output)
                else:
                    raise

        if raises is not None:
            exception_type = raises.get("type")
            message = raises.get("message")

            try:
                result.exception_was_raised(exception_type)
                exception_message = self._story_friendly_output(
                    result.exception.message
                )
                strings_match(message, exception_message)
            except Failure:
                if self._rewrite:
                    new_raises = raises.copy()
                    new_raises["message"] = exception_message
                    self.current_step.update(raises=new_raises)
                else:
                    raise

    def tear_down(self):
        if self.path.q.exists():
            print(self.path.q.text())
