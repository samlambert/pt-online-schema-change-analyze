use strict;

package pt_online_schema_change_plugin;

sub new {
   my ($class, %args) = @_;
   my $self = { %args };
   return bless $self, $class;
}

sub init {
    my ($self, %args) = @_;
}

# This fuction just exists just to set new_tbl which is not passed to before_swap_tables
sub after_create_new_table {
   my ($self, %args) = @_;
   $self->{new_tbl} = $args{new_tbl};
}

sub before_swap_tables {
   my ($self, %args) = @_;
   my $dbh = $self->{aux_cxn}->dbh;
   my $new_tbl = $self->{new_tbl};

   print "Running: ANALYZE TABLE " . $new_tbl->{name} . ".\n";

   my @analyzed;
   # Because MySQL does not return an error if you try and analyze a table that does not
   # exist this is a select so we can read the results
   @analyzed = eval { $dbh->selectrow_array("ANALYZE TABLE " . $new_tbl->{name}) };
   if ( $@ ) {
      print "ANALYZE TABLE failed with error:\n$@\n";
      exit;
   } elsif (!@analyzed) {
      print "ANALYZE TABLE failed with error:\n", $dbh->errstr, "\n";
      exit;
   } elsif (@analyzed[2] =~ /error/i ) {
      print "ANALYZE TABLE failed with error:\n @analyzed[3]\n";
      exit;
   } else {
      print "ANALYZE succeeded with output:\n @analyzed[3]\n";
      return;
   }
}
1;
