use Test;
plan 10;

# Note: Icky way of identifying code to be highlighed but not
# checked: ```Raku vs ```Raku -/test

my $read-me = "README.md".IO.slurp;

$read-me ~~ /^ $<waffle>=.*? +%% ["```Raku -test" \n? $<code>=.*? "```" \n?] $/
    or die "README.md parse failed";

for @<code> {
    my $snippet = ~$_;
    given $snippet {
	default {
            # ensure consistant document ID generation
            srand(123456);

	    # assume anything else is code.
	    $snippet = $snippet.subst('DateTime.now;', 'DateTime.new( :year(2015), :month(12), :day(25) );' );
	    # disable say, etc
	    sub say(|c) { }
	    sub dd(|c) { }
	    sub note(|c) { }
	    lives-ok {EVAL $snippet}, 'code sample'
		or warn "eval error: $snippet";
	}
    }
}

done-testing;
