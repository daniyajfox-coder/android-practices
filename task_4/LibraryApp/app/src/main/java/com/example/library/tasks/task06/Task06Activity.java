package com.example.library.tasks.task06;

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

/** Калькулятор возраста питомца */
public class Task06Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task06_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task06_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int INT = InputType.TYPE_CLASS_NUMBER;

        final EditText et = Ui.edit(this, "Возраст собаки (лет)", INT);
        Button btn = Ui.button(this, "Перевести в собачьи годы");
        final TextView res = Ui.text(this, "", 20);
        btn.setOnClickListener(v -> {
            String s = Ui.str(et);
            if (s.isEmpty()) { Ui.toast(this, "Введите возраст!"); return; }
            try {
                int years = Integer.parseInt(s);
                res.setTextColor(Color.BLACK);
                res.setText(years + " лет = " + (years * 7) + " собачьих лет");
            } catch (NumberFormatException e) { Ui.toast(this, "Ошибка ввода числа!"); }
        });
        Ui.add(c, et, btn, res);
    }
}
