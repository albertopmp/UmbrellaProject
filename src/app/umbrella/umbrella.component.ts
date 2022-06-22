import { Component, OnInit } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ConfirmSnackbarComponent } from '../confirm-snackbar/confirm-snackbar.component';

@Component({
  selector: 'app-umbrella',
  templateUrl: './umbrella.component.html',
  styleUrls: ['./umbrella.component.scss']
})
export class UmbrellaComponent implements OnInit {
  constructor(private _snackBar: MatSnackBar) {}

  ngOnInit(): void {
    this.openSnackBar();
  }

  openSnackBar() {
    this._snackBar.openFromComponent(ConfirmSnackbarComponent);
  }
}
