package com.example.library.tasks.task07;

import android.os.Bundle;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Счетчик символов */
public class Task07Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task07_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task07_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);

        final EditText et = Ui.edit(this, "Введите текст", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE);
        final TextView tv = Ui.text(this, "Символов: 0", 20);
        et.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int st, int cnt, int after) {}
            @Override public void onTextChanged(CharSequence s, int st, int before, int cnt) {
                tv.setText("Символов: " + s.length());
            }
            @Override public void afterTextChanged(Editable s) {}
        });
        Ui.add(c, et, tv);
    }
}
