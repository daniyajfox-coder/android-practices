package com.example.library.tasks.task24;

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

/** Конструктор визитки мастера: ввод данных */
public class Task24Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step1);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task24_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task24_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int TXT = InputType.TYPE_CLASS_TEXT;
        Button btnNext = findViewById(R.id.btnNext);

        final EditText name = Ui.edit(this, "Имя", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_WORDS);
        final EditText prof = Ui.edit(this, "Профессия", TXT);
        final EditText phone = Ui.edit(this, "Телефон", InputType.TYPE_CLASS_PHONE);
        Ui.add(c, name, prof, phone);
        btnNext.setText("Создать визитку");
        btnNext.setOnClickListener(v -> {
            String n = Ui.str(name), p = Ui.str(prof), t = Ui.str(phone);
            if (n.isEmpty() || p.isEmpty() || t.isEmpty()) { Ui.toast(this, "Заполните все поля!"); return; }
            Intent intent = new Intent(Task24Activity.this, Task24Step2Activity.class);
            intent.putExtra("KEY_NAME", n);
            intent.putExtra("KEY_PROF", p);
            intent.putExtra("KEY_PHONE", t);
            startActivity(intent);
        });
    }
}
