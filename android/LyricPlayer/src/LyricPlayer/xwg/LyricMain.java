package LyricPlayer.xwg;

import java.io.File;
import java.util.ArrayList;

import android.app.Activity;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;

public class LyricMain extends Activity implements LyricPlayerService.LyricPlayerListener
                                       , LyricPlayerServiceProxy.ServiceConnectionListener{
    private static final int REQUARE_MUSIC_FILE	= 1;
    private static final int REQUARE_LYRIC_FILE = 2;
	
	private LyricPlayerServiceProxy mProxy = new LyricPlayerServiceProxy(this);
    private ArrayList<Integer> mLyricEndList = new ArrayList<Integer>();
    private LyricDbAdapter mLyricDbAdapter;
    
    private EditText mLyricEdit = null;
   // private static final String TAG = new String("LyricMain");
        
    private class MyInfoProvider implements LyricPlayerService.LyricInfoProvider{
		String mUrl;
		String mTitle;
		String mLyricUrl;
		String mLyricEncoding;
		int mCurrentIndex;
		int mPlayMode = 0;
		private ArrayList<Integer> mMusicList;
		
		MyInfoProvider(ArrayList<Integer> music_list, int playMode){
			mPlayMode = playMode;
			mMusicList = music_list;
			moveTo(0);
		}
		
		@Override
		public boolean moveToPrev() {
			if(mPlayMode == R.id.menu_item_random){
				mCurrentIndex = (int)Math.round(Math.random() * (mMusicList.size() - 1));
				moveTo(mCurrentIndex);
				return true;
			}else{
				if(mPlayMode == R.id.menu_item_repeat){
					moveTo((mCurrentIndex + mMusicList.size() - 1) % mMusicList.size());	
					return true;
				}else{
					if(hasPrev()){
						moveTo(mCurrentIndex - 1);
						return true;
					}else{
						return false;
					}
				}
			}
		}
		
		public boolean hasPrev(){
			if(mPlayMode == R.id.menu_item_normal){
				return (mCurrentIndex > 0);
			}else{
				return true;
			}
		}
		
		@Override
		public boolean moveToNext() {
			if(mPlayMode == R.id.menu_item_random){
				mCurrentIndex = (int)Math.round(Math.random() * (mMusicList.size() - 1));
				moveTo(mCurrentIndex);
				return true;
			}else{
				if(mPlayMode == R.id.menu_item_repeat){
					moveTo((mCurrentIndex + 1) % mMusicList.size());
					return true;
				}else{
					if(hasNext()){
						moveTo(mCurrentIndex + 1);
						return true;
					}else{
						return false;
					}
				}
			}
		}
		
		public boolean hasNext(){
			if(mPlayMode == R.id.menu_item_normal){
				return (mCurrentIndex + 1 < mMusicList.size());
			}else{
				return true;
			}
		}
		
		@Override
		public String getUrl() {
			return mUrl;
		}
		
		@Override
		public String getTitle() {
			// TODO Auto-generated method stub
			return mTitle;
		}
		
		public void setLyricUrl(String url){
			mLyricUrl = url;
		}

		@Override
		public String getLyricUrl() {
			// TODO Auto-generated method stub
			return mLyricUrl;
		}

		@Override
		public String getLyricTitle() {
			// TODO Auto-generated method stub
			return null;
		}
		
		public void setLyricEncoding(String encoding){
			mLyricEncoding = encoding;
		}

		@Override
		public String getLyricEncoding() {
			return mLyricEncoding;
		}
		
		private void moveTo(int index){
			Cursor cursor = mLyricDbAdapter.fetchMusic(mMusicList.get(index));
			if(cursor.getCount() > 0){
				mUrl = cursor.getString(cursor.getColumnIndex(LyricDbAdapter.KEY_MUSIC_URL));
				mTitle = cursor.getString(cursor.getColumnIndex(LyricDbAdapter.KEY_MUSIC_TITLE));
				mLyricUrl = cursor.getString(cursor.getColumnIndex(LyricDbAdapter.KEY_LYRIC_URL));
				mLyricEncoding = cursor.getString(cursor.getColumnIndex(LyricDbAdapter.KEY_LYRIC_ENCODING));
			}
			cursor.close();
			mCurrentIndex = index;
			onMusicChanged();
		}

		@Override
		public void onMusicChanged() {
			TextView tv = (TextView)findViewById(R.id.fileTitle);
			tv.setText(getTitle());
			mLyricDbAdapter.updatePlaytime(getUrl());
		}
	}
    
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        mLyricDbAdapter = new LyricDbAdapter(LyricMain.this);
        mLyricDbAdapter.open();
		
        mLyricEdit = (EditText)this.findViewById(R.id.editLyric);
        
        mProxy.setConnectionListener(this);
        mProxy.setLyricPlayerListener(this);
        mProxy.setNotificationProvider(new MediaPlayerService.NotificationProvider(){
			@Override
			public Notification createNotification(Context context) {
				Notification notification = new Notification(R.drawable.button_blue_play, mProxy.getTitle(), System.currentTimeMillis());
				// The PendingIntent to launch our activity if the user selects this notification
				PendingIntent contentIntent = PendingIntent.getActivity(context, 0, new Intent(context, LyricMain.class), 0); 
				// Set the info for the views that show in the notification panel.
				notification.setLatestEventInfo(context, getText(R.string.media_player_label), mProxy.getTitle(), contentIntent);
				return notification;
			}
		});
        mProxy.startAndBindService();
        mLyricEndList.clear();
        
        DisplayMetrics metrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(metrics);
                
        int btnId[] = {R.id.buttonPrev, R.id.buttonStop, R.id.buttonPlay, R.id.buttonPause, R.id.buttonNext};
        int btnSize = Math.min(metrics.widthPixels, metrics.heightPixels) / (btnId.length + 1);
        
        for(int i = 0; i < btnId.length; ++i){
        	ImageButton ib = (ImageButton)this.findViewById(btnId[i]);
        	ib.setAdjustViewBounds(true);
        	ib.setMaxHeight(btnSize);
        	ib.setMaxWidth(btnSize);
        }
        ImageButton selectFile = (ImageButton)this.findViewById(R.id.buttonSelectFile);
        selectFile.setAdjustViewBounds(true);
        selectFile.setMaxHeight(btnSize);
        selectFile.setMaxWidth(btnSize);
    	
        updateButtonState();
    }
    
    @Override
	protected void onDestroy() {
    	super.onDestroy();
    	mProxy.setConnectionListener(null);
        mProxy.setLyricPlayerListener(null);
    	if(!mProxy.isPlaying()){
            mProxy.stopService();
        }
    	mLyricDbAdapter.close();
	}
    
    public void OnSelectFile(View v){
    	//Intent i = new Intent(this, SelectFileActivity.class);
    	Intent i = new Intent(this, SelectMusicActivity.class);
    	startActivityForResult(i, REQUARE_MUSIC_FILE);
    }
    
    @Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    	MyInfoProvider provider;
		switch(requestCode){
		case REQUARE_MUSIC_FILE:
			if(resultCode != RESULT_OK) return;
			if(data == null) return;
			Bundle bundle = data.getExtras();
			ArrayList<Integer> music_list = bundle.getIntegerArrayList(SelectMusicActivity.KEY_SELECTION);
			provider = new MyInfoProvider(music_list, bundle.getInt(SelectMusicActivity.KEY_PLAY_MODE));
			mProxy.setLyricInfoProvider(provider);
			mProxy.start();
			break;
		case REQUARE_LYRIC_FILE:
			if(resultCode != RESULT_OK) return;
			provider = (MyInfoProvider)mProxy.getLyricInfoProvider();
			provider.setLyricUrl(data.getStringExtra(SelectLyricActivity.KRY_LYRIC_URL));
			mProxy.setLyricInfoProvider(provider);
			break;
		default:
			super.onActivityResult(requestCode, resultCode, data);
			break;
		}
	}

	public void OnOperationButtonClick(View v){
    	switch(v.getId()){
    	case R.id.buttonPrev:
    		mProxy.playPrev();
    		break;
    	case R.id.buttonStop:
    		if(mProxy.isPlaying() || mProxy.isPausing()){
                mProxy.stop();
            }
    		break;
    	case R.id.buttonPlay:
    		if(!mProxy.isPlaying()){
            	mProxy.start();
            }
    		break;
    	case R.id.buttonPause:
    		if(mProxy.isPlaying()){
                mProxy.pause();
            }
    		break;
    	case R.id.buttonNext:
    		mProxy.playNext();
    		break;
    	}
     }
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		LyricPlayerService.LyricInfoProvider provider = mProxy.getLyricInfoProvider();
		if(provider != null){
			MenuInflater inflater = getMenuInflater();
			inflater.inflate(R.menu.main_menu, menu);
			return true;
		}else{
			return false;
		}
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		MyInfoProvider provider = (MyInfoProvider)mProxy.getLyricInfoProvider();
		switch(item.getItemId()){
		case R.id.menu_item_select_lyric:
			String music_url = provider.getUrl();
			String music_dir = music_url.substring(0, music_url.lastIndexOf('/'));
			Intent intent = new Intent();
			intent.putExtra("explorer_title", "title");
			intent.setDataAndType(Uri.fromFile(new File(music_dir)), "*/*");
			intent.setClass(this, SelectLyricActivity.class);
			startActivityForResult(intent, REQUARE_LYRIC_FILE);
			return true;
		case R.id.menu_item_gb2312:
		case R.id.menu_item_utf_8:
			provider.setLyricEncoding(item.getTitle().toString());
			mProxy.setLyricInfoProvider(provider);
			return true;
		default:
			return super.onOptionsItemSelected(item);
		}
	}

	protected void updateButtonState(){
		LyricPlayerService.LyricInfoProvider provider = mProxy.getLyricInfoProvider();
		((ImageButton)this.findViewById(R.id.buttonPrev)).setEnabled((provider != null) && provider.hasPrev());
		((ImageButton)this.findViewById(R.id.buttonStop)).setEnabled(mProxy.isPlaying() || mProxy.isPausing());
		((ImageButton)this.findViewById(R.id.buttonPlay)).setEnabled(mProxy.getDataSource()!= null && (!mProxy.isPlaying() || mProxy.isPausing()));
		((ImageButton)this.findViewById(R.id.buttonPause)).setEnabled(mProxy.isPlaying());
		((ImageButton)this.findViewById(R.id.buttonNext)).setEnabled((provider != null) && provider.hasNext());
	}
	
	
	
	//implement of LyricPlayerServiceProxy.ServiceConnectionListener
	public void onServiceConnected(){
    	String title = mProxy.getTitle();
        if(title != null){
        	TextView tv = (TextView)this.findViewById(R.id.fileTitle);
			tv.setText(title);
        }
        updateButtonState();
    }
	public void onServiceDisconnected(){
		
	}
	
	//implement of LyricPlayerService.LyricPlayerListener
    public void onLyricLoaded(){
    	mLyricEndList.clear();
    	String lyric = new String();
    	for(int i = 0; i < mProxy.getLyricCount(); ++i){
    		lyric += mProxy.getLyric(i);
    		lyric += "\r\n";
    		mLyricEndList.add(new Integer(lyric.length()));
    	}
    	mLyricEdit.setText(lyric);
    	if(lyric.length() > 0){
    		MyInfoProvider provider = (MyInfoProvider)mProxy.getLyricInfoProvider();
    		mLyricDbAdapter.updateLyricInfo(provider.getUrl(), provider.getLyricUrl(), provider.getLyricEncoding());
    	}
     }
    
    public void onStateChanged(){
    	updateButtonState();
    }
    
	public void onPositionChanged(long position){
		
	}
    
    public void onLyricChanged(int lyric_index){
    	if(mLyricEndList.size() == 0) return;
        int lyricStart = 0;
    	if(lyric_index > 0){
    		lyricStart = mLyricEndList.get(lyric_index - 1);
    	}
    	int lyricEnd = mLyricEndList.get(lyric_index);
    	mLyricEdit.setSelection(lyricStart, lyricEnd);
    	mLyricEdit.invalidate();
    	//Log.i(TAG, String.format("lyric= %d, setSelection(%d, %d)", lyric_index, lyricStart, lyricEnd));
    }
    
    public void OnLyricClick(View v){
		EditText et = (EditText)v;
		int sel_start = et.getSelectionStart();
		for(int i = 0; i < mLyricEndList.size(); ++i){
    		if(sel_start < mLyricEndList.get(i))
    		{
    			mProxy.seekToLyric(i);
    			break;
    		}
		}
	}
}