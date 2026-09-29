package com.example.library.tasks.task13;

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

/** Конвертер температур */
public class Task13Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task13_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task13_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);
        final int DEC = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;
        final int DECS = DEC | InputType.TYPE_NUMBER_FLAG_SIGNED;

        final EditText et = Ui.edit(this, "Градусы Цельсия", DECS);
        Button bf = Ui.button(this, "В Фаренгейты");
        Button bk = Ui.button(this, "В Кельвины");
        final TextView res = Ui.text(this, "", 20);
        bf.setOnClickListener(v -> {
            try {
                double t = Ui.num(et);
                res.setText(String.format(Locale.getDefault(), "%.1f °C = %.1f °F", t, t * 1.8 + 32));
            } catch (NumberFormatException e) { Ui.toast(this, "Введите число!"); }
        });
        bk.setOnClickListener(v -> {
            try {
                double t = Ui.num(et);
                if (t < -273.15) { Ui.toast(this, "Ниже абсолютного нуля!"); return; }
                res.setText(String.format(Locale.getDefault(), "%.1f °C = %.2f K", t, t + 273.15));
            } catch (NumberFormatException e) { Ui.toast(this, "Введите число!"); }
        });
        Ui.add(c, et, bf, bk, res);
    }
}
