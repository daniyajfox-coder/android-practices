package com.example.library.tasks.task23;

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

/** Квиз из двух вопросов: результат */
public class Task23Step2Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step2);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task23_title_result);
        LinearLayout c = findViewById(R.id.layoutContainer);
        Button btnBack = findViewById(R.id.btnBack);
        btnBack.setOnClickListener(v -> finish());

        final int score1 = getIntent().getIntExtra("KEY_SCORE", 0);
        c.addView(Ui.text(this, "Вопрос 2: В каких единицах задают размер шрифта?", 18));
        final String[] ans = {"dp", "sp", "px"};
        final RadioGroup rg = new RadioGroup(this);
        for (String s : ans) {
            RadioButton rb = new RadioButton(this);
            rb.setId(View.generateViewId());
            rb.setText(s);
            rg.addView(rb);
        }
        final Button finish = Ui.button(this, "Завершить");
        final TextView res = Ui.text(this, "", 22);
        c.addView(rg);
        c.addView(finish);
        c.addView(res);
        finish.setOnClickListener(v -> {
            int idx = rg.indexOfChild(findViewById(rg.getCheckedRadioButtonId()));
            if (idx < 0) { Ui.toast(this, "Выберите вариант ответа!"); return; }
            int total = score1 + (idx == 1 ? 1 : 0);
            Ui.ok(res, "Итоговый балл: " + total + " из 2");
            finish.setEnabled(false);
            for (int i = 0; i < rg.getChildCount(); i++) rg.getChildAt(i).setEnabled(false);
        });
        btnBack.setText("Назад");
    }
}
