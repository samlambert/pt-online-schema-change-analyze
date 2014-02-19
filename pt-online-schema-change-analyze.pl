use strict;

package pt_online_schema_change_plugin;

sub new {
   my ($class, %args) = @_;
   my $self = { %args };
   return bless $self, $class;
}

sub init {
   my ($self, %args) = @_;
   $self->{orig_tbl} = $args{orig_tbl};
}

# After swapping the tables at the end of the migration an ANALYZE TABLE will run.
sub after_swap_tables {
   my ($self, %args) = @_;
   my $dbh      = $self->{aux_cxn}->dbh;
   my $orig_tbl = $self->{orig_tbl};
   print "Running: ANALYZE TABLE " . $orig_tbl->{name} . ".\n";
   $dbh->do("ANALYZE TABLE " . $orig_tbl->{name});
   return;
}
1;
