import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormControl, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Observable, Subscription } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ConfirmSnackbarComponent } from '../confirm-snackbar/confirm-snackbar.component';
import { UmbrellaData } from '../model/umbrella-data';
import { TimerService } from '../service/timer.service';
import { UmbrellaService } from '../service/umbrella.service';

@Component({
  selector: 'app-umbrella',
  templateUrl: './umbrella.component.html',
  styleUrls: ['./umbrella.component.scss']
})
export class UmbrellaComponent implements OnInit, OnDestroy {
  checkingInterval: Subscription;

  mncpCode = '15078';
  totalSubscribers = 0;
  umbrellaData: UmbrellaData;

  emailFormControl = new FormControl('', [Validators.required, Validators.email]);

  constructor(
    private _snackBar: MatSnackBar,
    private umbrellaService: UmbrellaService,
    private timerService: TimerService
  ) {}

  ngOnInit() {
    this.startTimer();
  }

  ngOnDestroy(): void {
    this.unsubscribeTimer();
  }

  startTimer() {
    this.checkingInterval = this.timerService.timer(0, environment.refreshTime).subscribe(() => {
      this.checkUmbrella();
      this.checkTotalSubscribers();
    });
  }

  unsubscribeTimer() {
    this.checkingInterval?.unsubscribe();
  }

  checkUmbrella() {
    this.umbrellaService
      .getUmbrellaBy(this.mncpCode)
      .subscribe((response) => (this.umbrellaData = response));
  }

  checkTotalSubscribers() {
    this.umbrellaService
      .getTotalSubscribers()
      .subscribe((response) => (this.totalSubscribers = response));
  }

  subscribeToTopic() {
    if (this.emailFormControl.valid) {
      this.umbrellaService.subscribeToTopicBy(this.emailFormControl.value).subscribe({
        next: () => {
          this.openSnackbar;
        }
      });
    }
  }

  openSnackbar() {
    this._snackBar.openFromComponent(ConfirmSnackbarComponent, { horizontalPosition: 'start' });
  }
}
