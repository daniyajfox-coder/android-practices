package com.example.library.tasks.task23;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Квиз из двух вопросов: ввод данных */
public class Task23Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step1);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task23_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task23_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        Button btnNext = findViewById(R.id.btnNext);

        Ui.add(c, Ui.text(this, "Вопрос 1: Как в Android называется отдельный экран приложения?", 18));
        final String[] ans = {"Activity", "Intent", "Layout"};
        final RadioGroup rg = new RadioGroup(this);
        for (String s : ans) {
            RadioButton rb = new RadioButton(this);
            rb.setId(View.generateViewId());
            rb.setText(s);
            rg.addView(rb);
        }
        c.addView(rg);
        btnNext.setText("Далее");
        btnNext.setOnClickListener(v -> {
            int idx = rg.indexOfChild(findViewById(rg.getCheckedRadioButtonId()));
            if (idx < 0) { Ui.toast(this, "Выберите вариант ответа!"); return; }
            int score1 = (idx == 0) ? 1 : 0;
            Intent intent = new Intent(Task23Activity.this, Task23Step2Activity.class);
            intent.putExtra("KEY_SCORE", score1);
            startActivity(intent);
        });
    }
}
