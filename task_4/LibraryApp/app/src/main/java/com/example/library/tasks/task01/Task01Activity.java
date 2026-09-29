package com.example.library.tasks.task01;

import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;

/** Светофор */
public class Task01Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task01_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task01_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);

        final View root = findViewById(android.R.id.content);
        Button r = Ui.button(this, "Красный");
        Button y = Ui.button(this, "Жёлтый");
        Button g = Ui.button(this, "Зелёный");
        r.setOnClickListener(v -> root.setBackgroundColor(Color.RED));
        y.setOnClickListener(v -> root.setBackgroundColor(Color.parseColor("#FFC107")));
        g.setOnClickListener(v -> root.setBackgroundColor(Color.GREEN));
        Ui.add(c, r, y, g);
    }
}
