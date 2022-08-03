import { Component, OnInit } from '@angular/core';
import { FormControl, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ConfirmSnackbarComponent } from '../confirm-snackbar/confirm-snackbar.component';
import { UmbrellaData } from '../model/umbrella-data';
import { UmbrellaService } from '../service/umbrella.service';

@Component({
  selector: 'app-umbrella',
  templateUrl: './umbrella.component.html',
  styleUrls: ['./umbrella.component.scss']
})
export class UmbrellaComponent implements OnInit {
  mncpCode = '15078';
  totalSubscribers = 1976;
  umbrellaData: UmbrellaData;

  emailFormControl = new FormControl('', [Validators.required, Validators.email]);

  constructor(private _snackBar: MatSnackBar, private umbrellaService: UmbrellaService) {}

  ngOnInit() {
    this.umbrellaService.getUmbrellaBy(this.mncpCode).subscribe((response) => {
      this.umbrellaData = UmbrellaData.deserialize(JSON.parse(response.body));
    });
  }

  openSnackBar() {
    if (this.emailFormControl.valid) {
      this._snackBar.openFromComponent(ConfirmSnackbarComponent, { horizontalPosition: 'start' });
    }
  }
}
