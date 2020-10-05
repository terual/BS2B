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
    my ($class, $client, $params, $callback, @args) = @_;
	
    if ($params->{'saveSettings'}) {

		$prefs->client($client)->set('bs2b', $params->{'pref_bs2b'} || 0);

		Plugins::BS2B::Plugin::setupTranscoder($client);
    }
	
	$params->{'prefs'}->{'pref_bs2b'}= $prefs->client($client)->get('bs2b') || 0;
	
    return $class->SUPER::handler($client, $params);
}

1;
