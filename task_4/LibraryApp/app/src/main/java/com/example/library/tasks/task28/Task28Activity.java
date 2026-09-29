package com.example.library.tasks.task28;

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

/** Анкета спортивного трекера: ввод данных */
public class Task28Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step1);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task28_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task28_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int INT = InputType.TYPE_CLASS_NUMBER;
        Button btnNext = findViewById(R.id.btnNext);

        final EditText goal = Ui.edit(this, "Цель на день (шагов)", INT);
        final EditText done = Ui.edit(this, "Пройдено за день (шагов)", INT);
        Ui.add(c, goal, done);
        btnNext.setText("Показать прогресс");
        btnNext.setOnClickListener(v -> {
            long g, d;
            try { g = Long.parseLong(Ui.str(goal)); d = Long.parseLong(Ui.str(done)); }
            catch (NumberFormatException e) { Ui.toast(this, "Заполните оба поля целыми числами!"); return; }
            if (g <= 0 || d < 0 || g > 1_000_000_000L || d > 1_000_000_000L) {
                Ui.toast(this, "Цель > 0, шаги ≥ 0 (до 1 млрд)"); return;
            }
            Intent intent = new Intent(Task28Activity.this, Task28Step2Activity.class);
            intent.putExtra("KEY_GOAL", (int) g);
            intent.putExtra("KEY_DONE", (int) d);
            startActivity(intent);
        });
    }
}
