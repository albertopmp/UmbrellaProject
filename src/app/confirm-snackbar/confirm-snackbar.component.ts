import { Component, OnInit } from '@angular/core';
import { MatSnackBarRef } from '@angular/material/snack-bar';

@Component({
  selector: 'app-confirm-snackbar',
  templateUrl: './confirm-snackbar.component.html',
  styleUrls: ['./confirm-snackbar.component.scss']
})
export class ConfirmSnackbarComponent implements OnInit {
  constructor(private snackBarRef: MatSnackBarRef<ConfirmSnackbarComponent>) {}

  ngOnInit(): void {}

  onClick() {
    this.snackBarRef.dismiss();
  }
}
