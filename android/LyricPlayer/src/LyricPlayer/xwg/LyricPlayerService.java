package LyricPlayer.xwg;

import android.media.MediaPlayer;
import android.os.Binder;
import android.os.IBinder;

public class LyricPlayerService extends MediaPlayerService implements LyricAdapter.LyricListener{
	public class LocalBinder extends Binder {   
        public LyricPlayerService getService() {   
            return LyricPlayerService.this ;   
        }   
    }
    
    private final IBinder mBinder = new  LocalBinder();
    
    @Override
    IBinder getBinder(){
    	return mBinder;
    }
    
    public interface LyricPlayerListener{
    	public void onPositionChanged(long position);
    	public void onStateChanged();
    	public void onLyricChanged(int lyric_index);
		public void onLyricLoaded();
    }
    
    private LyricPlayerListener mLyricPlayerListener = null;
    
    void setLyricPlayerListener(LyricPlayerListener listener){
    	mLyricPlayerListener = listener;
    	if(mLyricPlayerListener != null)
    	{
    		mLyricPlayerListener.onLyricLoaded();
    		int curLyric = mLyricAdapter.getCurrentLyric();
    		if(curLyric >= 0 && curLyric < mLyricAdapter.getLyricCount()){
    			mLyricPlayerListener.onLyricChanged(curLyric);
    		}
    	}
    }
	
	private LyricAdapter mLyricAdapter = new LyricAdapter();
    
	private SafetyTimer mLyricTimer = new SafetyTimer(500, new SafetyTimer.OnTimeListener(){
    	public void OnTimer(){
    		if(mMediaPlayer != null){
    			int position = mMediaPlayer.getCurrentPosition();
    			if(mLyricPlayerListener != null){
    				mLyricPlayerListener.onPositionChanged(position);
    			}
    			mLyricAdapter.notifyTime(position);
    		}
        }	
	});
	
	@Override
    public void onCreate() {
        super.onCreate();
        mLyricAdapter.setListener(this);
    }

    @Override
    public void onDestroy() {
    	super.onDestroy();
    	mLyricAdapter = null;
    }
    
    interface LyricInfoProvider extends MediaPlayerService.MediaInfoProvider{
    	String getLyricUrl();
    	String getLyricTitle();
    	String getLyricEncoding();
    	void onMusicChanged();
    }
    
    private LyricInfoProvider mLyricInfoProvider;
    
    public void setLyricInfoProvider(LyricInfoProvider provider) {
    	if(mLyricInfoProvider != provider){
    		super.setMediaInfoProvider(provider);
    		mLyricInfoProvider = provider;
    	}
    	loadLyric();
    } 
    
    public LyricInfoProvider getLyricInfoProvider() { 
       	return mLyricInfoProvider;
    } 
    
    @Override
    public void start() {
    	if(isStop()){
    		super.start();
    		mLyricTimer.startTimer();
    	}else{
    		super.start();
    	}
    	if(mLyricPlayerListener != null){
    		mLyricPlayerListener.onStateChanged();
    	}
    }   
    
    @Override
    public void stop() {
    	mLyricTimer.stopTimer();
        super.stop();
        if(mLyricPlayerListener != null){
    		mLyricPlayerListener.onStateChanged();
    	}
    }   
    
    @Override
    public void pause() {
    	super.pause();
        if(mLyricPlayerListener != null){
    		mLyricPlayerListener.onStateChanged();
    	}
    }
    
    @Override
    public boolean playNext(){
    	if(isPlaying()){
    		seekToNextLyric();
    		return true;
    	}else{
    		if(super.playNext()){
    			loadLyric();
    			return true;
    		}else{
    			return false;
    		}
    	}
    }
    
    @Override
    public boolean playPrev(){
    	if(isPlaying()){
    		seekToPrevLyric();
    		return true;
    	}else{
    		if(super.playPrev()){
    			loadLyric();
    			return true;
    		}else{
    			return false;
    		}
    	}
    }
    
    public void loadLyric(){
    	if(mLyricInfoProvider != null){
    		String strLyricFileUrl = mLyricInfoProvider.getLyricUrl();
    		mLyricAdapter.LoadLyric(strLyricFileUrl, mLyricInfoProvider.getLyricEncoding());
    	}
    	if(mLyricPlayerListener != null){
    		mLyricPlayerListener.onStateChanged();
    	}
    }
    
    public int getLyricCount(){
    	return mLyricAdapter.getLyricCount();
    }
    
    public String getLyric(int index){
    	return mLyricAdapter.getLyric(index);
    }
    
    public long seekToLyric(int index){
    	long position = mLyricAdapter.getLyricTime(index);
    	if(position != -1){
    		return seek(position);
    	}else{
    		return 0;
    	}
    }
    
    public void seekToPrevLyric(){
    	int curLyric =  mLyricAdapter.getCurrentLyric();
    	if(curLyric > 0){
    		seekToLyric(curLyric - 1);
    	}
    }
    
    public void seekToNextLyric(){
    	int curLyric =  mLyricAdapter.getCurrentLyric();
    	if(curLyric < mLyricAdapter.getLyricCount() - 1){
    		seekToLyric(curLyric + 1);
    	}
    }
    
    @Override
	public void onCompletion(MediaPlayer mp) {
		if(mLyricTimer.isRunging()){
			mLyricTimer.stopTimer();
		}
		if(mLyricPlayerListener != null){
			mLyricPlayerListener.onStateChanged();
		}
		super.onCompletion(mp);
		playNext();
	}  
    
    @Override
    public void onLyricChanged(int lyric_index){
    	if(mLyricPlayerListener != null){
    		mLyricPlayerListener.onLyricChanged(lyric_index);
    	}
    }
    
    @Override
	public void onLyricLoaded(){
		if(mLyricPlayerListener != null){
    		mLyricPlayerListener.onLyricLoaded();
    		mLyricPlayerListener.onStateChanged();
    	}
	}
}
