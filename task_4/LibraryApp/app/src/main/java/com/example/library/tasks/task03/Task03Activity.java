package com.example.library.tasks.task03;

import android.graphics.Color;
import android.os.Bundle;
import android.text.InputType;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Мини-тест с одной кнопкой */
public class Task03Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task03_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task03_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);

        TextView q = Ui.text(this, "Вопрос: столица Франции?", 18);
        final EditText et = Ui.edit(this, "Ваш ответ", InputType.TYPE_CLASS_TEXT);
        Button btn = Ui.button(this, "Проверить");
        final TextView res = Ui.text(this, "", 20);
        btn.setOnClickListener(v -> {
            String a = Ui.str(et);
            if (a.isEmpty()) { Ui.toast(this, "Введите ответ!"); return; }
            if (a.equalsIgnoreCase("Париж")) { res.setTextColor(Color.GREEN); res.setText("Верно!"); }
            else { res.setTextColor(Color.RED); res.setText("Ошибка!"); }
        });
        Ui.add(c, q, et, btn, res);
    }
}
