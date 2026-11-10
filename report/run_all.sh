#!/bin/bash
# Запускает автопроверки всех трёх практических работ. Использование: ./run_all.sh
cd "$(dirname "$0")" || exit 1
for n in 7 8 9; do
  echo "=== Практическая работа №$n ==="
  dart run --enable-asserts task_${n}_solutions.dart --test || echo "❌ №$n завершилась с ошибкой"
done
