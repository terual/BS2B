package Plugins::BS2B::Plugin;

use strict;

use base qw(Slim::Plugin::OPMLBased);

use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Slim::Player::TranscodingHelper;

use Plugins::BS2B::PlayerSettings;

my $prefs = preferences('plugin.bs2b');

my $log = Slim::Utils::Log->addLogCategory({
	'category'     => 'plugin.bs2b',
	'defaultLevel' => 'WARN',
	'description'  => 'PLUGIN_BS2B',
});

sub initPlugin {
	my $class = shift;

	Plugins::BS2B::PlayerSettings->new;

	Slim::Control::Request::subscribe(\&initClient, [['client'],['new','reconnect']]);
}

sub setupTranscoder {
    my $client = $_[0] || return;

	my $usebs2b   = $prefs->client($client)->get('bs2b');

	my $flc = 'flc-flc-*-' . lc($client->macaddress);

	if ($usebs2b) {
		
		# AU is specifically designed to be written to a pipe (http://www.mega-nerd.com/libsndfile/FAQ.html#Q017) 
		my $cmdTable    = '[sox] -q -t flac $FILE$ -t au - $START$ | [bs2bconvert] /dev/stdin /dev/stdout | [sox] -q -t au - -t flac -C 0 -';
		my $capabilities = { F => 'noArgs', T => 'START=trim %s' };

		$Slim::Player::TranscodingHelper::commandTable{ $flc } = $cmdTable;
		$Slim::Player::TranscodingHelper::capabilities{ $flc } = $capabilities;
		
	} else {
		
		$Slim::Player::TranscodingHelper::commandTable{ $flc } = "-";
		$Slim::Player::TranscodingHelper::capabilities{ $flc } = {};
		
	}		
}

sub initClient {
    my $request = shift;
  
    setupTranscoder($request->client());
}

1;
