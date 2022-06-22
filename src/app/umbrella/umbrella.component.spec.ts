import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UmbrellaComponent } from './umbrella.component';

describe('UmbrellaComponent', () => {
  let component: UmbrellaComponent;
  let fixture: ComponentFixture<UmbrellaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [UmbrellaComponent]
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(UmbrellaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
