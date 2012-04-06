package LyricPlayer.xwg;

import java.io.IOException;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.Service;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Binder;
import android.os.IBinder;
import android.os.PowerManager;

public class MediaPlayerService extends Service implements MediaPlayer.OnCompletionListener,
                                  MusicFocusable{
	
	// Unique Identification Number for the Notification.
	// We use it on Notification start, and to cancel it.
	private int NOTIFICATION = R.string.local_service_started;
	private NotificationManager mNotificationManager;
	private ComponentName mReceiverName = null;
	
	private AudioManager mAudioManager = null;
    protected MediaPlayer mMediaPlayer = null;
    private boolean mIsPausing = false;
    
    //our AudioFocusHelper object, if it's available (it's available on SDK level >= 8)
    // If not available, this will be null. Always check for null before using!
    AudioFocusHelper mAudioFocusHelper = null;
    
    
    public class LocalBinder extends Binder {   
        public MediaPlayerService getService() {   
            return MediaPlayerService.this ;   
        }   
    }
    
    private final IBinder mBinder =  new  LocalBinder();
    private boolean mBinded = false;
    
    
    IBinder getBinder(){
    	return mBinder;
    }
    
    @Override
    public IBinder onBind(Intent intent) {
    	mBinded = true;
        return getBinder();
    }
    
 @Override
	public void onRebind(Intent intent) {
	    mBinded = true;
		super.onRebind(intent);
	}

@Override
	public boolean onUnbind(Intent intent) {
	    mBinded = false;
		return super.onUnbind(intent);
	}

	public interface MediaInfoProvider{
    	String getUrl();
    	String getTitle();
    	boolean moveToNext();
    	boolean moveToPrev();
    	boolean hasNext();
    	boolean hasPrev();
    }
    private MediaInfoProvider mMediaInfoProvider = null;
    private String mDataSource;
    private String mTitle;
    
    public void setMediaInfoProvider(MediaInfoProvider provider) {  
    	if( mDataSource != provider.getUrl() && (isStop() == false)){
    		stop();
    	}
    	mMediaInfoProvider = provider;
    	mDataSource = provider.getUrl();
    	mTitle = provider.getTitle();
    }
    
    public MediaInfoProvider getMediaInfoProvider() {  
    	return mMediaInfoProvider;
    }
    
    @Override
    public void onCreate() {
        super.onCreate();
        
        mMediaPlayer = new MediaPlayer();
        
        // Make sure the media player will acquire a wake-lock while playing. If we don't do
        // that, the CPU might go to sleep while the song is playing, causing playback to stop.
        //
        // Remember that to use this, we have to declare the android.permission.WAKE_LOCK
        // permission in AndroidManifest.xml.
        mMediaPlayer.setWakeMode(getApplicationContext(), PowerManager.PARTIAL_WAKE_LOCK);
        
        mMediaPlayer.setOnCompletionListener(this);
        
        mNotificationManager = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
        mAudioFocusHelper = new AudioFocusHelper(getApplicationContext(), this);
        
        // create the Audio Focus Helper, if the Audio Focus feature is available (SDK 8 or above)
        if (android.os.Build.VERSION.SDK_INT >= 8){
            mReceiverName = new ComponentName(getPackageName(),MediaButtonReceiver.class.getName());
        	mAudioManager = (AudioManager)getSystemService(Context.AUDIO_SERVICE);
        	mAudioManager.registerMediaButtonEventReceiver(mReceiverName);
        }
    }

    @Override
    public void onDestroy() {
    	super.onDestroy();
    	mAudioFocusHelper.giveUpAudioFocus();
    	if(mAudioManager != null && mReceiverName != null){
    		mAudioManager.unregisterMediaButtonEventReceiver(mReceiverName);
    	}
    	mMediaPlayer.setOnCompletionListener(null);
    	if(!isStop()){
    		stop();
    	}
    	mMediaPlayer.release();
        mMediaPlayer = null;
    }
    
    public String getTitle(){
    	return mTitle;
    }

    public String getDataSource(){
        return mDataSource;
    }
    
    public void start() {
    	mAudioFocusHelper.tryToGetAudioFocus();
    	if(!isPausing()){
    		if(isPlaying()){
    			stop();
    		}
    		try{   
	            mMediaPlayer.reset();   
	            mMediaPlayer.setDataSource(mDataSource);   
	            mMediaPlayer.prepare(); 
	        }catch(IOException e) {   
	            return;   
	        } catch  (IllegalArgumentException e) {   
	            return;   
	        }   
	        mMediaPlayer.start();
    	}else{
    		mIsPausing = false;
            mMediaPlayer.start();
    	}
    	showNotification();
    }   
    
    public void stop() {
    	mAudioFocusHelper.giveUpAudioFocus();
        mMediaPlayer.stop();  
        mIsPausing = false;
        mNotificationManager.cancel(NOTIFICATION);
    }   
    
    public void pause() {
    	mAudioFocusHelper.giveUpAudioFocus();
    	mIsPausing = true;
        mMediaPlayer.pause();
    }
    
    public boolean playNext(){
    	if(isPlaying() || isPausing()){
			stop();
		}
    	if(mMediaInfoProvider.moveToNext()){
    		mDataSource = mMediaInfoProvider.getUrl();
        	mTitle = mMediaInfoProvider.getTitle();
    		start();
    		return true;
    	}else{
    		return false;
    	}
    }
    
    public boolean playPrev(){
    	if(isPlaying() || isPausing()){
			stop();
		}
    	if(mMediaInfoProvider.moveToPrev()){
    		mDataSource = mMediaInfoProvider.getUrl();
        	mTitle = mMediaInfoProvider.getTitle();
    		start();
    		return true;
    	}else{
    		return false;
    	}
    }
    
    public boolean isPausing(){
    	return mIsPausing;
    }
    
    public boolean isPlaying() {   
        return mMediaPlayer.isPlaying();   
    }  
    
    public boolean isStop(){
    	return (isPlaying() == false && isPausing() == false);
    }
    
    public int getDuration() {   
        return mMediaPlayer.getDuration();   
    }   
       
    public int getPosition() {   
        return mMediaPlayer.getCurrentPosition();   
    }   
    
    public long seek(long whereto) {
    	mMediaPlayer.seekTo((int ) whereto);
     	return whereto;
    }
    
    public static final String ACTION_PAUSE = "MediaPlayer.xwg.action.PAUSE";
	public static final String ACTION_PLAY_PAUSE = "MediaPlayer.xwg.action.PLAY_PAUSE";
	public static final String ACTION_PREVIOUS = "MediaPlayer.xwg.action.PREVIOUS";
	public static final String ACTION_NEXT = "MediaPlayer.xwg.action.NEXT";
    @Override
	public int onStartCommand(Intent intent, int flags, int startId) {
    	String action = intent.getAction();
    	if(action != null)
    	{
	        if (action.equals(ACTION_PLAY_PAUSE)){
	        	if(isPlaying()){
	        		pause();
	        	}else{
	        		start();
	        	}
	        }else if (action.equals(ACTION_PAUSE)){
	        	if(isPlaying())
	        	{
	        		pause();
	        	}
	        }else if (action.equals(ACTION_PREVIOUS)){
	        	if(isPlaying() || isPausing())
	        	{
	        		playPrev();
	        	}
	        }else if (action.equals(ACTION_NEXT)){
	        	if(isPlaying() || isPausing())
	        	{
	        		playNext();
	        	}
	        }
    	}
        return START_NOT_STICKY; // Means we started the service, but don't want it to
            // restart in case it's killed.
	}
    
   @Override
	public void onCompletion(MediaPlayer mp) {
	   	mIsPausing = false;
		mNotificationManager.cancel(NOTIFICATION);
		if(mBinded == false){
			stopSelf();
		}
	}  
    
	// The volume we set the media player to when we lose audio focus, but are allowed to reduce
    // the volume instead of stopping playback.
    public final float DUCK_VOLUME = 0.1f;
    
    @Override
    public void onGainedAudioFocus() {
        // restart media player with new focus settings
        if (isPausing())
            configAndStartMediaPlayer();
    }

	
	@Override
	public void onLostAudioFocus() {
        // start/restart/pause media player with new focus settings
        if (mMediaPlayer != null && mMediaPlayer.isPlaying())
            configAndStartMediaPlayer();
    }
	
	/**
     * Reconfigures MediaPlayer according to audio focus settings and starts/restarts it. This
     * method starts/restarts the MediaPlayer respecting the current audio focus state. So if
     * we have focus, it will play normally; if we don't have focus, it will either leave the
     * MediaPlayer paused or set it to a low volume, depending on what is allowed by the
     * current focus settings. This method assumes mPlayer != null, so if you are calling it,
     * you have to do so from a context where you are sure this is the case.
     */
    void configAndStartMediaPlayer() {
        if (mAudioFocusHelper.getAudioFocus() == AudioFocusHelper.NoFocusNoDuck) {
            // If we don't have audio focus and can't duck, we have to pause, even if mState
            // is State.Playing. But we stay in the Playing state so that we know we have to resume
            // playback once we get the focus back.
            if (isPlaying()) pause();
            return;
        }
        else if (mAudioFocusHelper.getAudioFocus() == AudioFocusHelper.NoFocusCanDuck)
        	mMediaPlayer.setVolume(DUCK_VOLUME, DUCK_VOLUME);  // we'll be relatively quiet
        else
        	mMediaPlayer.setVolume(1.0f, 1.0f); // we can be loud

        if (isPausing()) start();
    }
    
    public interface NotificationProvider{
    	public Notification createNotification(Context context);
    }
    
    NotificationProvider mNotificationProvider = null;
    
    public void setNotificationProvider(NotificationProvider provider){
    	mNotificationProvider = provider;
    }
    
    /** * Show a notification while this service is running.     */
	private void showNotification() {
		if(mNotificationProvider != null){
		// Send the notification.
			mNotificationManager.notify(NOTIFICATION, mNotificationProvider.createNotification(this));    
		}
	}
}
