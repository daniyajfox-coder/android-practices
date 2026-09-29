package com.example.library.tasks.task29;

import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Задание №29: экран описания термина. */
public class Task29DetailActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_step2);

        String[] names = {"Activity", "Intent", "Layout"};
        String[] descriptions = {
                "Activity — один экран Android-приложения. Содержит интерфейс и логику; "
                        + "должна быть объявлена в AndroidManifest.xml.",
                "Intent — «намерение»: объект для запуска другого экрана (startActivity) "
                        + "и передачи данных через putExtra/getExtra. Бывает явным и неявным.",
                "Layout — разметка интерфейса в XML: контейнеры (LinearLayout, ConstraintLayout) "
                        + "и виджеты (TextView, Button, EditText), определяющие внешний вид экрана."
        };

        int termIndex = getIntent().getIntExtra("KEY_TERM_INDEX", 1);
        int i = Math.max(0, Math.min(names.length - 1, termIndex - 1));

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(names[i]);
        LinearLayout c = findViewById(R.id.layoutContainer);
        c.addView(Ui.text(this, descriptions[i], 18));

        Button btnBack = findViewById(R.id.btnBack);
        btnBack.setOnClickListener(v -> finish());
    }
}
