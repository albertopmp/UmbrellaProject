import { Injectable } from '@angular/core';
import { Observable, timer } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class TimerService {
  constructor() {
    // No operation
  }

  public timer(delay: number, period: number): Observable<number> {
    return timer(delay, period);
  }
}
