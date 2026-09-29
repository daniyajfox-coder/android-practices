package com.example.library.tasks.task11;

import android.os.Bundle;
import android.text.InputType;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;
import java.util.Locale;

/** Индекс массы тела (ИМТ) */
public class Task11Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task11_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task11_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int DEC = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;

        final EditText w = Ui.edit(this, "Вес (кг)", DEC);
        final EditText h = Ui.edit(this, "Рост (см)", DEC);
        Button btn = Ui.button(this, "Рассчитать ИМТ");
        final TextView res = Ui.text(this, "", 20);
        btn.setOnClickListener(v -> {
            try {
                double weight = Ui.num(w), height = Ui.num(h) / 100.0;
                if (weight <= 0 || height <= 0) { Ui.toast(this, "Значения должны быть больше нуля"); return; }
                double bmi = weight / (height * height);
                String verdict = bmi < 18.5 ? "Дефицит" : (bmi < 25 ? "Норма" : "Избыток");
                res.setText(String.format(Locale.getDefault(), "ИМТ = %.1f — %s", bmi, verdict));
            } catch (NumberFormatException e) { Ui.toast(this, "Заполните оба поля числами!"); }
        });
        Ui.add(c, w, h, btn, res);
    }
}
