package LyricPlayer.xwg;

import java.util.ArrayList;
import java.util.Calendar;

import android.app.TabActivity;
import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.ListView;
import android.widget.TabHost;
import android.widget.TabHost.TabSpec;
import android.widget.TextView;
import android.widget.Toast;

@SuppressWarnings("deprecation")
public class SelectMusicActivity extends TabActivity {
	public final static String KEY_SELECTION = "rowid";
	public final static String KEY_PLAY_MODE = "play_mode";
	
	private LyricDbAdapter mLyricDbAdapter;
	private Cursor mCursorAll;
	private Cursor mCursorRecent;
	private ListView mFileListAll;
	private ListView mFileListRecent;
	private TextView mEmptyTextAll;
	private TextView mEmptyTextRecent;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.select_file_tab);  
		
		mLyricDbAdapter = new LyricDbAdapter(this);
		mLyricDbAdapter.open();
		
		TabHost tabs = getTabHost();  
          
        TabSpec tabAllFiles = tabs.newTabSpec("All");  
        tabAllFiles.setIndicator("All", getResources().getDrawable(R.drawable.music));  
        tabAllFiles.setContent(R.id.all_music);  
        tabs.addTab(tabAllFiles);
          
        mFileListAll = (ListView)this.findViewById(R.id.all_music_list);
        mEmptyTextAll = (TextView)this.findViewById(R.id.all_music_empty);
        mCursorAll = mLyricDbAdapter.fetchAllNotes();
        if(mCursorAll.getCount() == 0){
        	mLyricDbAdapter.updateMediaFiles();
        	mCursorAll = mLyricDbAdapter.fetchAllNotes();
        }
        
        buildFileList(mFileListAll, mCursorAll, mEmptyTextAll, "Please fine files from menu.");

        TabSpec tabRecentFiles = tabs.newTabSpec("Recent");  
        tabRecentFiles.setIndicator("Recent", getResources().getDrawable(R.drawable.playlist_icon_selector));  
        tabRecentFiles.setContent(R.id.recent_music); 
        tabs.addTab(tabRecentFiles);              
        
        mFileListRecent = (ListView)this.findViewById(R.id.recent_music_list);
        mEmptyTextRecent = (TextView)this.findViewById(R.id.recent_music_empty);
        
        Calendar c = Calendar.getInstance();
		c.roll(Calendar.DAY_OF_MONTH, -10);
        mCursorRecent = mLyricDbAdapter.fetchRecentPlayAfter(c.getTime());
        
        buildFileList(mFileListRecent, mCursorRecent, mEmptyTextRecent, "Recent files.");
        tabs.setCurrentTab(0);  
	}
	
	@Override
	protected void onStop() {
		mCursorAll.close();
		mCursorRecent.close();
		mLyricDbAdapter.close();
		super.onStop();
	}

	void buildFileList(ListView lv, Cursor cursor, TextView tv, String text){
		int count = cursor.getCount();
		if(count > 0){
		   startManagingCursor(cursor);
	       
	       String[] from = new String[] {LyricDbAdapter.KEY_MUSIC_TITLE, LyricDbAdapter.KEY_MUSIC_DURATION};
	       int[] to = new int[]{R.id.music_title, R.id.music_duration};
	       
	       CheckBoxCursorAdapter adapter = 
	           new CheckBoxCursorAdapter(this,R.layout.music_info_row, cursor, from ,to, 
	        		   R.id.checkBox, LyricDbAdapter.KEY_ROWID);
	       
	       lv.setAdapter(adapter);
	       lv.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
	       tv.setText("");
		}else{
			tv.setText(text);
		}
	}
	
	CheckBoxCursorAdapter getCurrentAdapter(){
		TabHost tabs = getTabHost(); 
		if(tabs.getCurrentTab() == 0){
			return (CheckBoxCursorAdapter)mFileListAll.getAdapter();
		}else{
			return (CheckBoxCursorAdapter)mFileListRecent.getAdapter();
		}
	}
	
	private void finishSuccessfully(ArrayList<Integer> idlist, int mode) {
		if(idlist.size() > 0){
			Intent i = new Intent(SelectMusicActivity.this, SelectMusicActivity.class);
			i.putIntegerArrayListExtra(KEY_SELECTION, idlist);
			i.putExtra(KEY_PLAY_MODE, mode);
			SelectMusicActivity.this.setResult(RESULT_OK, i);
			SelectMusicActivity.this.finish();
		}
    }
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.select_file_menu, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();
		switch(id){
		case R.id.menu_item_normal:
		case R.id.menu_item_random:
		case R.id.menu_item_repeat:
			finishSuccessfully(getCurrentAdapter().getSelectedItems(), id);
		case R.id.menu_item_seek_music:
			mLyricDbAdapter.updateMediaFiles();
			buildFileList(mFileListAll, mCursorAll, mEmptyTextAll, "Please fine files from menu.");
		default:
			return super.onOptionsItemSelected(item);
		}
	}
}
