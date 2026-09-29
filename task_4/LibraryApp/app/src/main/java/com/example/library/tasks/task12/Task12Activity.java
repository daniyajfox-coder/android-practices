package com.example.library.tasks.task12;

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

/** Калькулятор расхода топлива */
public class Task12Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task12_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task12_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int DEC = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;

        final EditText d = Ui.edit(this, "Расстояние (км)", DEC);
        final EditText l = Ui.edit(this, "Потрачено (л)", DEC);
        Button btn = Ui.button(this, "Рассчитать расход");
        final TextView res = Ui.text(this, "", 20);
        btn.setOnClickListener(v -> {
            try {
                double km = Ui.num(d), liters = Ui.num(l);
                if (km <= 0 || liters < 0) { Ui.toast(this, "Расстояние > 0, литры ≥ 0"); return; }
                res.setText(String.format(Locale.getDefault(), "Расход: %.2f л на 100 км", liters / km * 100));
            } catch (NumberFormatException e) { Ui.toast(this, "Заполните оба поля числами!"); }
        });
        Ui.add(c, d, l, btn, res);
    }
}
