package com.example.library.tasks.task20;

import android.graphics.Color;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Оценщик надежности пароля */
public class Task20Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task20_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task20_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);

        final EditText et = Ui.edit(this, "Введите пароль", InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
        final TextView res = Ui.text(this, "Введите пароль", 22);
        et.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int st, int cnt, int after) {}
            @Override public void onTextChanged(CharSequence s, int st, int before, int cnt) {
                int len = s.length();
                if (len == 0) { res.setTextColor(Color.GRAY); res.setText("Введите пароль"); }
                else if (len < 6) { res.setTextColor(Color.RED); res.setText("Слабый"); }
                else if (len <= 10) { res.setTextColor(Color.parseColor("#F9A825")); res.setText("Средний"); }
                else { res.setTextColor(Color.parseColor("#2E7D32")); res.setText("Надёжный"); }
            }
            @Override public void afterTextChanged(Editable s) {}
        });
        Ui.add(c, et, res);
    }
}
