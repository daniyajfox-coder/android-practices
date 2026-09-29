package com.example.library.tasks.task25;

import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Дневник заметок: ввод данных */
public class Task25Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step1);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task25_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task25_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        Button btnNext = findViewById(R.id.btnNext);

        final EditText note = Ui.edit(this, "Текст заметки", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE);
        note.setMinLines(5);
        note.setGravity(android.view.Gravity.TOP);
        c.addView(note);
        btnNext.setText("Читать");
        btnNext.setOnClickListener(v -> {
            String t = note.getText().toString().trim();
            if (t.isEmpty()) { Ui.toast(this, "Заметка пуста!"); return; }
            Intent intent = new Intent(Task25Activity.this, Task25Step2Activity.class);
            intent.putExtra("KEY_NOTE", t);
            startActivity(intent);
        });
    }
}
