import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ConfirmSnackbarComponent } from './confirm-snackbar.component';

describe('ConfirmSnackbarComponent', () => {
  let component: ConfirmSnackbarComponent;
  let fixture: ComponentFixture<ConfirmSnackbarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ConfirmSnackbarComponent]
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
