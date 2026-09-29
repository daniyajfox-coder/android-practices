package com.example.library.tasks.task02;

import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;
import java.util.Random;

/** Генератор случайных чисел */
public class Task02Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task02_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task02_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);

        final Random rnd = new Random();
        Button btn = Ui.button(this, "Бросить кубик");
        final TextView tv = Ui.text(this, "?", 48);
        tv.setGravity(android.view.Gravity.CENTER);
        btn.setOnClickListener(v -> tv.setText(String.valueOf(rnd.nextInt(6) + 1)));
        Ui.add(c, btn, tv);
    }
}
