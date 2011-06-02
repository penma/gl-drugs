package OpenGL::State;

use strict;
use warnings;

use OpenGL qw(:all);

use Exporter 'import';
our @EXPORT = qw(save_matrixmode save_blendfunc save_matrices save_matrix save_feature);

sub save_matrixmode(&) {
	my ($code) = @_;
	my $old = glGetIntegerv_p(GL_MATRIX_MODE);
	$code->();
	glMatrixMode($old);
}

sub save_feature {
	my ($feature, $code) = @_;
	my $old = glIsEnabled($feature);
	$code->();
	if ($old) {
		glEnable($feature);
	} else {
		glDisable($feature);
	}
}

sub save_blendfunc(&) {
	my ($code) = @_;
	my $src = glGetIntegerv_p(GL_BLEND_SRC);
	my $dst = glGetIntegerv_p(GL_BLEND_DST);
	$code->();
	glBlendFunc($src, $dst);
}

sub save_matrices {
	my ($matrices, $code) = @_;
	save_matrixmode {
		foreach my $matrix (@{$matrices}) {
			glMatrixMode($matrix);
			glPushMatrix();
		}
	};
	$code->();
	save_matrixmode {
		foreach my $matrix (reverse @{$matrices}) {
			glMatrixMode($matrix);
			glPopMatrix();
		}
	};
}

sub save_matrix {
	my ($matrix, $code) = @_;
	save_matrices([$matrix], $code);
}

1;
