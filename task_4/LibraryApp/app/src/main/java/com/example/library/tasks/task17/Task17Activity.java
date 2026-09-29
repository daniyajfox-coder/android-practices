package com.example.library.tasks.task17;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;
import java.util.Random;

/** Генератор надежного PIN-кода */
public class Task17Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task17_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task17_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);

        final Random rnd = new Random();
        Button b4 = Ui.button(this, "Сгенерировать 4-значный PIN");
        Button b6 = Ui.button(this, "Сгенерировать 6-значный PIN");
        final TextView tv = Ui.text(this, "----", 40);
        tv.setGravity(android.view.Gravity.CENTER);
        View.OnClickListener l = v -> {
            int len = v == b4 ? 4 : 6;
            StringBuilder sb = new StringBuilder();
            int prev = -1;
            while (sb.length() < len) {
                int d = rnd.nextInt(10);
                if (d == prev) continue; // соседние цифры должны различаться
                sb.append(d);
                prev = d;
            }
            tv.setText(sb.toString());
        };
        b4.setOnClickListener(l); b6.setOnClickListener(l);
        Ui.add(c, b4, b6, tv);
    }
}
