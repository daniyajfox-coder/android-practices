package com.example.library.tasks.task05;

import android.os.Bundle;
import android.text.InputType;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Инвертор текста */
public class Task05Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task05_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task05_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);

        final EditText et = Ui.edit(this, "Введите слово", InputType.TYPE_CLASS_TEXT);
        Button btn = Ui.button(this, "Перевернуть");
        final TextView res = Ui.text(this, "", 22);
        btn.setOnClickListener(v -> res.setText(new StringBuilder(et.getText().toString()).reverse().toString()));
        Ui.add(c, et, btn, res);
    }
}
