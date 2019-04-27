using DataDeps

register(DataDep("SemEval 2007t7",
    """
    Website: http://nlp.cs.swarthmore.edu/semeval/tasks/task07/description.shtml
    Data Website: http://nlp.cs.swarthmore.edu/semeval/tasks/task07/data.shtml
    Author: Roberto Navigli and Ken Litkowski

    The initial results and the task details are reported in:
    Navigli, R., Litkowski, K.C. and Hargraves, O., 2007, June. Semeval-2007 task 07: Coarse-grained english all-words task.
    _In Proceedings of the 4th International Workshop on Semantic Evaluations_ (pp. 30-35). Association for Computational Linguistics.
    Paper Website: http://anthology.aclweb.org/S/S07/S07-1.pdf#page=58
    """,
    "http://nlp.cs.swarthmore.edu/semeval/tasks/task07/data/".* ["trial", "test", "key"] .* ".tar.gz",
    "e0c1dc0d1644c019e28d36cacc837c5fd8c2a87bdafd34a7e71fa95a8b661dc7"
    ;
    post_fetch_method = unpack
))
