import { Calculator } from './calculator';

const calc = new Calculator();

const n1 = document.getElementById('num1') as HTMLInputElement;
const n2 = document.getElementById('num2') as HTMLInputElement;
const res = document.getElementById('result') as HTMLElement;

document.getElementById('addBtn')?.addEventListener('click', () => {
    if (n1 && n2) {
        const sum = calc.add(Number(n1.value), Number(n2.value));
        res.innerText = `Result: ${sum}`;
    }
});

document.getElementById('subBtn')?.addEventListener('click', () => {
    if (n1 && n2) {
        const diff = calc.subtract(Number(n1.value), Number(n2.value));
        res.innerText = `Result: ${diff}`;
    }
});