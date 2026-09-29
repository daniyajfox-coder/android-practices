package com.example.library.tasks.task19;

import android.os.Bundle;
import android.text.InputType;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Калькулятор времени в пути */
public class Task19Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task19_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task19_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int DEC = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;

        final EditText d = Ui.edit(this, "Расстояние (км)", DEC);
        final EditText s = Ui.edit(this, "Средняя скорость (км/ч)", DEC);
        Button btn = Ui.button(this, "Рассчитать время");
        final TextView res = Ui.text(this, "", 20);
        btn.setOnClickListener(v -> {
            try {
                double dist = Ui.num(d), speed = Ui.num(s);
                if (dist < 0 || speed <= 0) { Ui.toast(this, "Расстояние ≥ 0, скорость > 0"); return; }
                int totalMin = (int) Math.round(dist / speed * 60);
                res.setText("Время в пути: " + (totalMin / 60) + " ч " + (totalMin % 60) + " мин");
            } catch (NumberFormatException e) { Ui.toast(this, "Заполните оба поля числами!"); }
        });
        Ui.add(c, d, s, btn, res);
    }
}
