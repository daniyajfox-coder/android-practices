package com.example.library.tasks.task27;

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

/** Электронный билет на поезд: ввод данных */
public class Task27Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step1);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task27_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task27_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        Button btnNext = findViewById(R.id.btnNext);

        final EditText from = Ui.edit(this, "Станция отправления", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_WORDS);
        final EditText to = Ui.edit(this, "Станция прибытия", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_WORDS);
        Ui.add(c, from, to);
        btnNext.setText("Получить билет");
        btnNext.setOnClickListener(v -> {
            String f = Ui.str(from), t = Ui.str(to);
            if (f.isEmpty() || t.isEmpty()) { Ui.toast(this, "Введите обе станции!"); return; }
            Intent intent = new Intent(Task27Activity.this, Task27Step2Activity.class);
            intent.putExtra("KEY_FROM", f);
            intent.putExtra("KEY_TO", t);
            startActivity(intent);
        });
    }
}
