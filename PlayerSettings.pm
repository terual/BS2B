package Plugins::BS2B::PlayerSettings;

use strict;

use base qw(Slim::Web::Settings);

use Slim::Utils::Prefs;
use Slim::Utils::Log;
use Slim::Player::CapabilitiesHelper;

use Plugins::BS2B::Plugin;

my $prefs = preferences('plugin.bs2b');
my $log   = logger('plugin.bs2b');

sub getDisplayName {
    return 'PLUGIN_BS2B';
}

sub needsClient {
    return 1;
}

sub name {
    return Slim::Web::HTTP::CSRF->protectName('PLUGIN_BS2B');
}

sub page {
    return Slim::Web::HTTP::CSRF->protectURI('plugins/BS2B/settings/player.html');
}

sub handler {
    my ($class, $client, $params) = @_;

    if ( $client ) {

        if ($params->{saveSettings}) {

            $prefs->client($client)->set('bs2b', $params->{'pref_bs2b'} || 0);
            $prefs->client($client)->set('bs2b_crossfeed_level', $params->{'pref_bs2b_crossfeed_level'} || 'd');

        } 

        $params->{prefs}->{pref_bs2b}                   = $prefs->client($client)->get('bs2b') || 0;
        $params->{prefs}->{pref_bs2b_crossfeed_level}   = $prefs->client($client)->get('bs2b_crossfeed_level') || 'd';

        Plugins::BS2B::Plugin::setupTranscoder($client);

    }

    return $class->SUPER::handler($client, $params);
}

1;
