import { Component, OnInit } from '@angular/core';
import { FormControl, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ConfirmSnackbarComponent } from '../confirm-snackbar/confirm-snackbar.component';

@Component({
  selector: 'app-umbrella',
  templateUrl: './umbrella.component.html',
  styleUrls: ['./umbrella.component.scss']
})
export class UmbrellaComponent implements OnInit {
  totalSubscribers = 1976;

  emailFormControl = new FormControl('', [Validators.required, Validators.email]);

  constructor(private _snackBar: MatSnackBar) {}

  ngOnInit(): void {}

  openSnackBar() {
    this._snackBar.openFromComponent(ConfirmSnackbarComponent, { horizontalPosition: 'start' });
  }
}
