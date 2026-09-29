package com.example.library.tasks.task09;

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

/** Конвертер см в дюймы */
public class Task09Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task09_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task09_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int DEC = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;

        final EditText et = Ui.edit(this, "Сантиметры", DEC);
        Button btn = Ui.button(this, "Перевести в дюймы");
        final TextView res = Ui.text(this, "", 20);
        btn.setOnClickListener(v -> {
            try {
                double cm = Ui.num(et);
                res.setText(String.format(Locale.getDefault(), "%.2f см = %.2f дюйма", cm, cm / 2.54));
            } catch (NumberFormatException e) { Ui.toast(this, "Введите число!"); }
        });
        Ui.add(c, et, btn, res);
    }
}
