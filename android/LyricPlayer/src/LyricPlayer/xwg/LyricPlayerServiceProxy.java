package LyricPlayer.xwg;

import android.content.ComponentName;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;

public class LyricPlayerServiceProxy{
    private ContextWrapper mContextWrapper= null;
    private LyricPlayerService mPlaybackService =  null ; 
        
    private ServiceConnectionListener mConnectionListener = null;
    private LyricPlayerService.LyricPlayerListener mLyricListener = null;
    private MediaPlayerService.NotificationProvider mNotificationProvider = null;
    
    public interface ServiceConnectionListener{
    	public void onServiceConnected();
    	public void onServiceDisconnected();
    }
    
    void setConnectionListener(ServiceConnectionListener listener){
    	mConnectionListener = listener;
    }
    
    private ServiceConnection mPlaybackConnection = new ServiceConnection() {   
           public void onServiceConnected(ComponentName className, IBinder service) {     
               mPlaybackService = ((LyricPlayerService.LocalBinder)service).getService();
               mPlaybackService.setLyricPlayerListener(mLyricListener);
               mPlaybackService.setNotificationProvider(mNotificationProvider);
               if(mConnectionListener != null){
            	   mConnectionListener.onServiceConnected();
               }
           }
 
           public void onServiceDisconnected(ComponentName className) {
        	   mPlaybackService.setLyricPlayerListener(null);
        	   mPlaybackService = null;
        	   if(mConnectionListener != null){
            	   mConnectionListener.onServiceDisconnected();
               }
           }   
    };  
    
    LyricPlayerServiceProxy(ContextWrapper cw){
        mContextWrapper = cw;
    }
    
    void startAndBindService(){ 
        mContextWrapper.startService(new Intent(mContextWrapper ,LyricPlayerService.class));  
        mContextWrapper.bindService(new Intent(mContextWrapper, LyricPlayerService.class), mPlaybackConnection, Context.BIND_AUTO_CREATE);
    }
    
    void stopService(){
        if(mPlaybackService != null){
            mContextWrapper.stopService(new Intent(mContextWrapper ,LyricPlayerService.class));
        }
    }
    
    public String getTitle(){
    	if(mPlaybackService != null){
    		return mPlaybackService.getTitle();
    	}else{
    		return null;
    	}
    }
    
    public void setLyricInfoProvider(LyricPlayerService.LyricInfoProvider provider) {
       	mPlaybackService.setLyricInfoProvider(provider);
    }
    
    public LyricPlayerService.LyricInfoProvider getLyricInfoProvider() {
    	if(mPlaybackService != null){
    		return mPlaybackService.getLyricInfoProvider();
    	}else{
    		return null;
    	}
    }
    
    public void setNotificationProvider(MediaPlayerService.NotificationProvider provider){
    	mNotificationProvider = provider;
    }
    
    public String getDataSource(){
    	if(mPlaybackService != null){
            return mPlaybackService.getDataSource();
        }else{
            return null;
        }
    }
    
    public int getLyricCount(){
    	if(mPlaybackService != null){
            return mPlaybackService.getLyricCount();
        }else{
            return 0;
        }
    }
    
    public String getLyric(int index){
    	if(mPlaybackService != null){
            return mPlaybackService.getLyric(index);
        }else{
            return null;
        }
    }
    
    public void start() {
        if(mPlaybackService != null){
            mPlaybackService.start();
        }
    }   
    
    public void stop(){
        if(mPlaybackService != null){
        	mPlaybackService.stop();
        }
    }   
    
    public void pause() {
        if(mPlaybackService != null){
            mPlaybackService.pause();
        }
    }
    
    public boolean isPlaying() {
        if(mPlaybackService != null){
            return mPlaybackService.isPlaying();
        }else{
            return false;
        }
    }   
    
    public boolean isPausing(){
    	if(mPlaybackService != null){
            return mPlaybackService.isPausing();
        }else{
            return false;
        }
    }
    
    public int getDuration() {
        if(mPlaybackService != null){
            return mPlaybackService.getDuration();
        }else{
            return 0;
        }
    }   
       
    public int getPosition() {
        if(mPlaybackService != null){
            return mPlaybackService.getPosition();
        }else{
            return 0;
        }
    }
    
    public long seekToLyric(int index){
    	if(mPlaybackService != null){
            return mPlaybackService.seekToLyric(index);
        }else{
            return 0;
        }
    }
    
    public void playNext(){
    	if(mPlaybackService != null){
            mPlaybackService.playNext();
        }
    }
    
    public void playPrev(){
    	if(mPlaybackService != null){
            mPlaybackService.playPrev();
        }
    }
    
    public long seek(long whereto) {
        if(mPlaybackService != null){
            return mPlaybackService.seek(whereto);
        }else{
            return 0;
        }
    }   
    
    public void setLyricPlayerListener(LyricPlayerService.LyricPlayerListener listener){
    	mLyricListener = listener;
    	if(mPlaybackService != null){
            mPlaybackService.setLyricPlayerListener(mLyricListener);
        }
    }
};
