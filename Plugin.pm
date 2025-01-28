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

    my $usebs2b     = $prefs->client($client)->get('bs2b');
    my $bs2b_preset = $prefs->client($client)->get('bs2b_crossfeed_level');

    my $flc = 'flc-flc-*-' . lc($client->macaddress);
    my $mp3 = 'mp3-mp3-*-' . lc($client->macaddress);

    if ($usebs2b) {
        
        # AU is specifically designed to be written to a pipe (http://www.mega-nerd.com/libsndfile/FAQ.html#Q017) 
        my $flc_cmdTable     = '[sox] -q -t flac $FILE$ -t au - $START$ | [bs2bconvert] -l ' . $bs2b_preset . ' /dev/stdin /dev/stdout | [sox] -q -t au - -t flac -C 0 - ';
        my $flc_capabilities = { F => 'noArgs', T => 'START=trim %s' };

        $Slim::Player::TranscodingHelper::commandTable{ $flc } = $flc_cmdTable;
        $Slim::Player::TranscodingHelper::capabilities{ $flc } = $flc_capabilities;

        my $mp3_cmdTable     = '[sox] -q -t mp3 $FILE$ -t au - $START$ | [bs2bconvert] -l ' . $bs2b_preset . ' /dev/stdin /dev/stdout | [sox] -q -t au - -t wav - | [lame] --silent -q $QUALITY$ $RESAMPLE$ $BITRATE$ - ';
        my $mp3_capabilities = { F => 'noArgs', T => 'START=trim %s', IFB => 'BITRATE=--abr %B', 'D' => 'RESAMPLE=--resample %D' };

        $Slim::Player::TranscodingHelper::commandTable{ $mp3 } = $mp3_cmdTable;
        $Slim::Player::TranscodingHelper::capabilities{ $mp3 } = $mp3_capabilities;

    } else {

        # Revert to standard convert rules
		my $cmdTable    = '-';
		my $capabilities = { };
		
		$Slim::Player::TranscodingHelper::commandTable{ $flc } = $cmdTable;
		$Slim::Player::TranscodingHelper::capabilities{ $flc } = $capabilities;

		$Slim::Player::TranscodingHelper::commandTable{ $mp3 } = $cmdTable;
		$Slim::Player::TranscodingHelper::capabilities{ $mp3 } = $capabilities;

	}


}

sub initClient {
    my $request = shift;
  
    setupTranscoder($request->client());
}

1;
