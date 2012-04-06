package LyricPlayer.xwg;

import android.app.ListActivity;
import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;

public class SelectFileActivity extends ListActivity {
	private LyricDbAdapter mLyricDbAdapter;
	private Cursor mCursor;
	private ListView mFilelist;
	    
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.select_file_view);
		
		mLyricDbAdapter = new LyricDbAdapter(this);
		mLyricDbAdapter.open();
		
		mFilelist = this.getListView();
		
		mFilelist.setOnItemClickListener(new OnItemClickListener(){
	           @Override
	           public void onItemClick(AdapterView<?> parent, View view,
	                   int position, long id) {
	               mCursor.moveToPosition(position);
	               Intent i = new Intent(SelectFileActivity.this, SelectFileActivity.class);
	       		   i.putExtra(LyricDbAdapter.KEY_ROWID, mCursor.getInt(mCursor.getColumnIndexOrThrow(LyricDbAdapter.KEY_ROWID)));
	       		   SelectFileActivity.this.setResult(RESULT_OK, i);
	       		   SelectFileActivity.this.finish();
	           }
	    });
		resetFileList();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.select_file_menu, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch(item.getItemId()){
		case R.id.menu_item_seek_music:
			mLyricDbAdapter.updateMediaFiles();
			resetFileList();
		default:
			return super.onOptionsItemSelected(item);
		}
	}
	
	void resetFileList(){
		if(mCursor != null){
			mCursor.close();
		}
		
		mCursor = mLyricDbAdapter.fetchAllNotes();
			
		int count = mCursor.getCount();
		
		TextView tv = (TextView)findViewById(android.R.id.empty);
		
		if(count > 0){
		   startManagingCursor(mCursor);
	       
	       String[] from = new String[] {LyricDbAdapter.KEY_MUSIC_TITLE, LyricDbAdapter.KEY_MUSIC_DURATION};
	    		   						
	       int[] to = new int[]{R.id.music_title, R.id.music_duration};
	       
	       SimpleCursorAdapter adapter = 
	           new SimpleCursorAdapter(this,R.layout.music_info_row, mCursor, from ,to);
	       
	       mFilelist.setAdapter(adapter);
	       tv.setText("");
		}else{
			tv.setText(R.string.find_file_info);
		}
	}
	
	
}
