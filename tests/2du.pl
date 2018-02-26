my $block_match = qr/(?<label>@\S+)\n(?<block>[^@]+)/;
my $use_match = qr/use\s*=(?<vars>\s*(?:\s+(%\S+))+)?/;
my $def_match = qr/def\s*=(?<vars>\s*(?:\s+(%\S+))+)?/;

use Exporter;
our @EXPORT_OK = our @EXPORT = qw(canonicalize);

sub canonicalize {
	my $text = shift;

	my @ret;
	while ($text =~ m/\G$block_match/g) {
		my %r = (label => $+{label});
		my $block = $+{block};
		my ($def) = $block =~ m/$def_match/g; $def=~s/^\s+//g; @{$r{def}} = sort split /\s+/, $def;
		my ($use) = $block =~ m/$use_match/g; $use=~s/^\s+//g; @{$r{use}} = sort split /\s+/, $use;

		push @ret, \%r;
	}
	return \@ret;
}

return \&canonicalize;
