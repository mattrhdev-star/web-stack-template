export class Calculator {
    add(a: number, b: number): number {
        return a + b;
    }

    subtract(a: number, b: number): number {
        return a - b;
    }
}

// src/index.ts
import { Calculator } from './calculator';

const calc = new Calculator();
console.log("Web Calculator Initialized.");
console.log(`2 + 3 = ${calc.add(2, 3)}`);