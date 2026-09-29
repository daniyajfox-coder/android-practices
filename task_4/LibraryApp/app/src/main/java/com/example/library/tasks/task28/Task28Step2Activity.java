package com.example.library.tasks.task28;

import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Анкета спортивного трекера: результат */
public class Task28Step2Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step2);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task28_title_result);
        LinearLayout c = findViewById(R.id.layoutContainer);
        Button btnBack = findViewById(R.id.btnBack);
        btnBack.setOnClickListener(v -> finish());

        int goal = getIntent().getIntExtra("KEY_GOAL", 1);
        int done = getIntent().getIntExtra("KEY_DONE", 0);
        int percent = (int) Math.min(100L, done * 100L / goal);
        c.addView(Ui.text(this, "Пройдено " + done + " из " + goal + " шагов", 18));
        ProgressBar pb = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
        pb.setMax(100);
        pb.setProgress(percent);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.topMargin = Ui.dp(this, 12);
        pb.setLayoutParams(lp);
        c.addView(pb);
        TextView tv = Ui.text(this, "Выполнено: " + percent + "%", 22);
        c.addView(tv);
        if (done >= goal) Ui.ok(tv, "Выполнено: " + percent + "% — норма выполнена!");
    }
}
