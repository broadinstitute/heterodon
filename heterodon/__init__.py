from clamp import clamp_base
from java.io import Serializable
from java.util.function import BiFunction
from java.util.function import Consumer
from java.util.function import Function

HeterodonBase = clamp_base("org.broadinstitute")


class Exec(HeterodonBase, Consumer, Serializable):
    def accept(self, exec_arg):
        exec (exec_arg, {})


class Eval(HeterodonBase, Function, Serializable):
    def apply(self, eval_arg):
        return eval(eval_arg, {})


class ExecAndEval(HeterodonBase, BiFunction, Serializable):
    def apply(self, exec_arg, eval_arg):
        shared_env = {}
        exec (exec_arg, shared_env)
        return eval(eval_arg, shared_env)
