import { CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { MatSnackBarModule, MatSnackBarRef } from '@angular/material/snack-bar';

import { ConfirmSnackbarComponent } from './confirm-snackbar.component';

describe('ConfirmSnackbarComponent', () => {
  let component: ConfirmSnackbarComponent;
  let fixture: ComponentFixture<ConfirmSnackbarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ConfirmSnackbarComponent],
      imports: [MatSnackBarModule],
      providers: [
        {
          provide: MatSnackBarRef,
          useValue: {}
        }
      ],
      schemas: [CUSTOM_ELEMENTS_SCHEMA]
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ConfirmSnackbarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
