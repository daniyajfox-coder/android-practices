package com.example.library.tasks.task30;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;

/** Портфолио: главный экран с тремя разделами */
public class Task30Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task30_main);

        Button btnAbout = findViewById(R.id.btnAbout);
        Button btnSkills = findViewById(R.id.btnSkills);
        Button btnContacts = findViewById(R.id.btnContacts);

        btnAbout.setOnClickListener(v -> startActivity(new Intent(this, Task30AboutActivity.class)));
        btnSkills.setOnClickListener(v -> startActivity(new Intent(this, Task30SkillsActivity.class)));
        btnContacts.setOnClickListener(v -> startActivity(new Intent(this, Task30ContactsActivity.class)));
    }
}
