package Padre::Plugin::Pastebin;

use 5.008;

use strict;
use warnings;

use Padre::Constant ();
use Padre::Plugin   ();
use Padre::Wx       ();

use Wx qw(:everything);

use WWW::Pastebin::PastebinCom::Create;

our @ISA = qw(Padre::Plugin);

our $VERSION = '0.01';

sub plugin_name { return 'Pastebin' }

sub padre_interfaces { 'Padre::Plugin' => 0.43 }

sub menu_plugins_simple {
    my $self = shift;

    return $self->plugin_name => [
        'paste' => sub { $self->paste },
    ]
}

sub paste {
    my $self = shift;

    my $editor = $self->current->editor;

    my $dialog = Wx::Dialog->new(
        $self->main,
        -1,
        'Pastebin',
        [ -1, -1 ],
        [ 560, 330 ],
        Wx::wxDEFAULT_FRAME_STYLE,
    );
        
    my $main_sizer   = Wx::GridBagSizer->new( 2, 0 );
        
    my $size   = Wx::Button::GetDefaultSize;
    my $ok_btn = Wx::Button->new( $dialog, Wx::wxID_OK, '', Wx::wxDefaultPosition, $size );
    
    my $code = $self->current->editor->GetText;
    
    my $paste = WWW::Pastebin::PastebinCom::Create->new;
    $paste->paste( text => $code );
    
    my $text   = Wx::TextCtrl->new(
        $dialog,
        -1,
        "$paste", 
        Wx::wxDefaultPosition, 
        [540,250],
        Wx::wxTE_READONLY
    );
    
    my $cur_font   = $text->GetFont;
    my $fixed_font = Wx::Font->new(
        $cur_font->GetPointSize,
        Wx::wxFONTFAMILY_TELETYPE,
        $cur_font->GetStyle,
        $cur_font->GetWeight,
        $cur_font->GetUnderlined,
    );
    
    $text->SetFont( $fixed_font );
    $text->SetSelection( 0, 0 );
    
    $main_sizer->Add( $text, Wx::GBPosition->new( 0, 0 ),
               Wx::GBSpan->new(1,1), wxLEFT | wxALIGN_CENTER_VERTICAL , 2);
    $main_sizer->Add( $ok_btn, Wx::GBPosition->new( 1, 0 ),
                Wx::GBSpan->new(1,1), wxLEFT | wxALIGN_CENTER_VERTICAL , 2);

    $dialog->SetSizer( $main_sizer );
    $dialog->SetAutoLayout(1);

    $dialog->ShowModal;
}

# ABSTRACT: Paste the code to pastebin

=head1 VERSION

Version 0.01


=head1 BUGS

Please report any bugs or feature requests to C<bug-padre::plugin::regexexplain at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Padre::Plugin::RegexExplain>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Padre-Plugin-Pastebin>

=item * Search CPAN

L<http://search.cpan.org/dist/Padre-Plugin-Pastebin/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Renee Baecker.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;
