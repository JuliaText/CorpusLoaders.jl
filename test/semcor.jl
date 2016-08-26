using CorpusLoaders
using Base.Test

@testset "Sense Annoations" begin
    @test parse_sense_annotated_word("""<wf cmd=done pos=JJ lemma=recent wnsn=2 lexsn=5:00:00:past:00>recent</wf>""") != false
    
    eg = """<wf cmd=done rdf=group pos=NNP lemma=group wnsn=1 lexsn=1:03:00:: pn=group>Fulton_County_Grand_Jury</wf>"""
    @test parse_sense_annotated_word(eg).pos == "NNP"
    @test parse_sense_annotated_word(eg).lemma == "group"
    @test parse_sense_annotated_word(eg).wnsn == "1"
    @test parse_sense_annotated_word(eg).lexsn == "1:03:00::"
    @test parse_sense_annotated_word(eg).word == "Fulton_County_Grand_Jury"

    
    @test parse_sense_annotated_word("""<wf cmd=done pos=JJ lemma=recent wnsn=2 lexsn=5:00:00:past:00>recent</wf>""") != false
    @test parse_sense_annotated_word("""<wf cmd=done pos=NN lemma=year wnsn=2;1 lexsn=1:28:02::;1:28:01::>year</wf>""") != false
    
    
    
    eg = """<wf cmd=done pos=NN lemma=report wnsn=20 lexsn=1:10:00::>reports</wf>"""
    display(parse_sense_annotated_word(eg))
    @test parse_sense_annotated_word(eg).pos == "NN"
    @test parse_sense_annotated_word(eg).lemma == "report"
    @test parse_sense_annotated_word(eg).wnsn == "20"
    @test parse_sense_annotated_word(eg).lexsn == "1:10:00::"
    @test parse_sense_annotated_word(eg).word == "reports"

end;

@testset "POS Tag Annoations" begin
    eg = """<wf cmd=ignore pos=IN>of</wf>"""
    @test parse_tagged_word(eg).pos == "IN"
    @test parse_tagged_word(eg).word == "of"
end;
