using Base.Test
using CorpusLoaders

@test brownPOStoWordNetPOS("NP") == 'n'
@test brownPOStoWordNetPOS("JJ") == 'a'


@test pennPOStoWordNetPOS("NNP") == 'n'
@test pennPOStoWordNetPOS("JJ") == 'a'
